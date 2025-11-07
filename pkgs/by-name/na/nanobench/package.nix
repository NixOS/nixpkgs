{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "nanobench";
  version = "4.3.11";

  src = fetchFromGitHub {
    owner = "martinus";
    repo = "nanobench";
    tag = "v${version}";
    hash = "sha256-6OoVU31cNY0pIYpK/PdB9Qej+9IJo7+fHFQCTymBVrk=";
  };

  patches = [
    # Missing header from a test file. Required for compiling as of gcc13. Patched in commit from master branch.
    # Remove on next release.
    (fetchpatch {
      url = "https://github.com/martinus/nanobench/commit/e4327893194f06928012eb81cabc606c4e4791ac.patch";
      hash = "sha256-vmpohg9TbIxT+p4JerWh/QBcZ3/+1gPSNf15sqW6leM=";
    })

    # Change cmake install directories to conventional locations. Patches from unmerged pull request.
    # Remove when merged upstream.
    (fetchpatch {
      url = "https://github.com/martinus/nanobench/pull/98/commits/92c6995ccaebbda87fed13de8eaf3d135d1af0c0.patch";
      hash = "sha256-JwCpwSRzV1qnwwcJIGEJWxthT4Vj12TXhAGG0bc8KGM=";
    })
    (fetchpatch {
      url = "https://github.com/martinus/nanobench/pull/98/commits/17a1f0b598a09d399dd492c72bca5b48ad76c794.patch";
      hash = "sha256-2lOD63qN7gywUQxrdSRVyddpzcQjjeWOrA3hqu7x+CY=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple, fast, accurate single-header microbenchmarking functionality for C++11/14/17/20";
    homepage = "https://nanobench.ankerl.com/";
    changelog = "https://github.com/martinus/nanobench/releases/tag/v${version}";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mtpham99 ];
  };
}
