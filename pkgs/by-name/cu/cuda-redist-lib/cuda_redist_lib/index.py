# NOTE: Open bugs in Pydantic like https://github.com/pydantic/pydantic/issues/8984 prevent the full switch to the type
# keyword introduced in Python 3.12.
from collections.abc import Mapping
from logging import Logger
from pathlib import Path
from typing import (
    Final,
    Self,
    TypeAlias,
)

from cuda_redist_lib.extra_pydantic import PydanticMapping, PydanticObject
from cuda_redist_lib.extra_types import (
    CudaVariant,
    PackageName,
    RedistName,
    RedistNames,
    RedistPlatform,
    Sha256,
    Version,
)
from cuda_redist_lib.logger import get_logger
from cuda_redist_lib.manifest import (
    NvidiaManifest,
    NvidiaPackage,
    NvidiaReleaseV2,
    NvidiaReleaseV3,
    get_nvidia_manifest,
    get_nvidia_manifest_versions,
)
from cuda_redist_lib.utilities import mk_relative_path

logger: Final[Logger] = get_logger(__name__)


class PackageInfo(PydanticObject):
    """
    A package in the manifest, with a hash and a relative path.

    The relative path is None when it can be reconstructed from information in the index.

    A case where the relative path is non-None: TensorRT, which does not follow the usual naming convention.
    """

    sha256: Sha256
    relative_path: None | Path = None


PackageVariants: TypeAlias = PydanticMapping[None | CudaVariant, PackageInfo]

Packages: TypeAlias = PydanticMapping[RedistPlatform, PackageVariants]


class ReleaseInfo(PydanticObject):
    """
    Top-level values in the manifest from keys not prefixed with release_, augmented with the package_name.
    """

    license_path: None | Path = None
    license: None | str = None
    name: None | str = None
    version: Version

    @classmethod
    def mk(cls: type[Self], nvidia_release: NvidiaReleaseV2 | NvidiaReleaseV3) -> Self:
        """
        Creates an instance of ReleaseInfo from the provided manifest dictionary, removing the fields
        used to create the instance from the dictionary.
        """
        return cls.model_validate({
            "license_path": nvidia_release.license_path,
            "license": nvidia_release.license,
            "name": nvidia_release.name,
            "version": nvidia_release.version,
        })


class Release(PydanticObject):
    release_info: ReleaseInfo
    packages: Packages

    @classmethod
    def mk(
        cls: type[Self],
        package_name: PackageName,
        nvidia_release: NvidiaReleaseV2 | NvidiaReleaseV3,
    ) -> Self:
        release_info = ReleaseInfo.mk(nvidia_release)

        packages: dict[RedistPlatform, PackageVariants] = {
            platform: mk_package_hashes(
                package_name,
                release_info,
                platform,
                package_or_cuda_variants_to_packages,
            )
            for platform, package_or_cuda_variants_to_packages in nvidia_release.packages().items()
        }

        return cls.model_validate({"release_info": release_info, "packages": packages})


Manifest: TypeAlias = PydanticMapping[PackageName, Release]

VersionedManifests: TypeAlias = PydanticMapping[Version, Manifest]

Index: TypeAlias = PydanticMapping[RedistName, VersionedManifests]


def mk_package_hashes(
    package_name: PackageName,
    release_info: ReleaseInfo,
    platform: RedistPlatform,
    package_or_cuda_variants_to_packages: NvidiaPackage | Mapping[CudaVariant, NvidiaPackage],
) -> PackageVariants:
    """
    Creates an instance of PackageInfo from the provided manifest dictionary, removing the fields
    used to create the instance from the dictionary.
    NOTE: Because the keys may be prefixed with "cuda", indicating multiple packages, we return a sequence of
    PackageInfo instances.
    """
    infos: dict[None | CudaVariant, PackageInfo] = {}
    for cuda_variant_name, nvidia_package in (
        {None: package_or_cuda_variants_to_packages}
        if isinstance(package_or_cuda_variants_to_packages, NvidiaPackage)
        else package_or_cuda_variants_to_packages
    ).items():
        sha256 = nvidia_package.sha256

        # Verify that we can compute the correct relative path before throwing it away.
        actual_relative_path = nvidia_package.relative_path
        expected_relative_path = mk_relative_path(package_name, platform, release_info.version, cuda_variant_name)
        package_info: PackageInfo
        if actual_relative_path != expected_relative_path:
            # TensorRT will fail this check because it doesn't follow the usual naming convention.
            if release_info.name != "NVIDIA TensorRT":
                logger.info("Expected relative path to be %s, got %s", expected_relative_path, actual_relative_path)
            package_info = PackageInfo.model_validate({"sha256": sha256, "relative_path": actual_relative_path})
        else:
            package_info = PackageInfo.model_validate({"sha256": sha256, "relative_path": None})

        infos[cuda_variant_name] = package_info
    return PackageVariants.model_validate(infos)


def mk_manifest(redist_name: RedistName, version: Version, nvidia_manifest: None | NvidiaManifest = None) -> Manifest:
    if nvidia_manifest is None:
        nvidia_manifest = get_nvidia_manifest(redist_name, version)

    releases: dict[str, Release] = {
        package_name: release
        for package_name, nvidia_release in nvidia_manifest.releases().items()
        # Don't include releases for packages that have no packages for the platforms we care about.
        if len((release := Release.mk(package_name, nvidia_release)).packages) != 0
    }

    return Manifest.model_validate(releases)


def mk_index() -> Index:
    return Index.model_validate({
        redist_name: {
            version: mk_manifest(redist_name, version) for version in get_nvidia_manifest_versions(redist_name)
        }
        for redist_name in RedistNames
    })
