{
  lib,
  stdenv,
  fetchgit,
  openssl,
  pkg-config,
  nss,
}:
let
  url = "https://chromium.googlesource.com/chromiumos/platform/vboot_reference";
  branch = "release-R144-16503.B";
in
stdenv.mkDerivation {
  pname = "futility";
  version = "0-${branch}";

  src = fetchgit {
    inherit url;
    rev = "refs/heads/${branch}";
    hash = "sha256-mij5cDezMYXAIdMlDACfGbck72UhtF4oLY7YWNQS2f8=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    nss
  ];

  postPatch = ''
    patchShebangs ./scripts
    substituteInPlace ./scripts/getversion.sh \
      --replace-fail "unknown" "${branch}"
  '';

  makeFlags = [
    "UB_DIR=$(out)/bin"
    "USE_FLASHROM=0"
  ];

  buildFlags = "futil";

  installTargets = "futil_install";

  meta = {
    homepage = url;
    description = "ChromeOS firmware utility";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "futility";
  };
}
