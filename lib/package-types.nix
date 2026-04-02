{ lib }:
# Types of packages
# A series of attribute sets which map different package types between various SBOM formats.
# Supporting:
# - CycloneDX Component Type: https://cyclonedx.org/docs/1.7/json/#components_items_type
# - SPDX Software Purpose vocab: https://spdx.github.io/spdx-spec/v3.0.1/model/Software/Vocabularies/SoftwarePurpose/
lib.genAttrs
  [
    "application"
    "framework"
    "library"
    "container"
    "platform"
    "device"
    "firmware"
    "file"
    "data"
  ]
  (name: {
    cyclonedx = name;
    spdx = name;
  })
// {
  operating-system = {
    cyclonedx = "operating-system";
    spdx = "operatingSystem";
  };
  device-driver = {
    cyclonedx = "device-driver";
    spdx = "deviceDriver";
  };
  disk-image = {
    cyclonedx = "file";
    spdx = "diskImage";
  };
  documentation = {
    cyclonedx = "file";
    spdx = "documentation";
  };
  executable = {
    cyclonedx = "application";
    spdx = "executable";
  };
  filesystem-image = {
    cyclonedx = "file";
    spdx = "filesystemImage";
  };
  patch = {
    cyclonedx = "file";
    spdx = "patch";
  };
}
