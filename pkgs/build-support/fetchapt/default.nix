{ stdenv, coreutils, fetchurl, gzip, nix }:

# Fetch the current version of a Debian-compatible binary package from an APT
# repository. This function performs minimal parsing of APT repository metadata
# to identify the current version of the named package, and returns a
# derivation that fetches the package file.
#
# This function contains multiple chained derivations to support interleaved
# downloading and parsing. Evaluating this function builds internal derivations
# that fetch repository metadata files over network.
#
# This function is non-deterministic but cache-friendly. Evaluating always
# downloads the base repository Release file so that the function can tell
# whether the repository has been updated. If the Release file has not been
# changed since last evaluation, all subsequent derivations will do nothing and
# return cached results. Using this function to fetch different packages from
# the same repository automatically reuses cached repository metadata files
# where appropriate.

let

  # Fetch a file from a URL and produce a content-addressable result. This
  # function is non-deterministic, but its result changes only if the fetched
  # file changes.  Returns Nix store path to the fetched file.
  prefetch = url:
    builtins.readFile (stdenv.mkDerivation {
      inherit nix url;
      buildInputs = [ nix ];
      name = "prefetch";
      builder = ./prefetch.sh;
      # TODO: support cusom cache TTL through parameterized trigger.
      dummy = builtins.currentTime;
    });

  # Extract SHA256 hash of target path from the given Release file.
  process_release = release: target:
    builtins.readFile (stdenv.mkDerivation {
      inherit release target;
      name = "process-release";
      builder = ./process-release.sh;
    });

  # Extract repository relative path and SHA256 hash of a package from
  # the given Packages file.
  process_packages = packages: target:
    let
      info = stdenv.mkDerivation {
        inherit coreutils gzip packages target;
        buildInputs = [ coreutils gzip ];
        name = "process-packages-${target}";
        builder = ./process-packages.sh;
      };
    in {
      filename = builtins.readFile "${info}/filename";
      sha256 = builtins.readFile "${info}/sha256";
    };

in

{ # Base URL for the APT repository, as listed in the sources.list file on
  # Debian-based systems. The URL cannot be a mirror reference because some
  # files are not fetched through fetchurl. Example:
  # http://http.debian.net/debian
  repository

, # Debian distribution, which can be a release codename (e.g., sid) or a suite
  # (e.g., stable).
  distribution ? "stable"

, # Debian package component, which is typically one of main, contrib, and
  # non-free.
  component ? "main"

, # Debian package architecture, as listed in www.debian.org/ports.
  arch ? "amd64"

, # Name of the Debian package to fetch, without version number (e.g., bash).
  package
}:

rec {

  dist_base = "${repository}/dists/${distribution}";

  # Fetch the repository top-level Release file, which lists the SHA256 hash of
  # the Packages file (to be obtained next). This step does not check hash
  # value because its purpose is to fetch the current version of the file.
  # TODO: support secure APT (wiki.debian.org/SecureApt).
  release_file = prefetch "${dist_base}/Release";

  # Fetch the relevant Packages.gz file and verify its integrity using the hash
  # value obtained from the Release file. This step chooses to fetch the gzip
  # compressed version of the Packages file, which seems to be most commonly
  # available in APT repositories.
  # TODO: support uncompressed and other compression formats.
  # TODO: support downloading source packages (cf. binary packages).
  packages_ref = "${component}/binary-${arch}/Packages.gz";
  packages_file = fetchurl {
    url = "${dist_base}/${packages_ref}";
    sha256 = process_release release_file packages_ref;
  };

  # Search the Packages file for the named package, and extract the relative
  # file path and the hash value of the package.
  package_info = process_packages packages_file package;

  # Download the package file and verify its integrity.
  package_file = fetchurl {
    url = "${repository}/${package_info.filename}";
    sha256 = package_info.sha256;
  };

}.package_file

