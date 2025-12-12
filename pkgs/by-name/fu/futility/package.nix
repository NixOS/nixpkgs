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
  branch = "release-R145-16552.B";
in
stdenv.mkDerivation {
  pname = "futility";
  version = "0-${branch}";

  src = fetchgit {
    inherit url;
    rev = "refs/heads/${branch}";
    hash = "sha256-LctTKkf8nTVcrErMiAkvSCYkZnBoTYjqxWj0xADi0Q4=";
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
  #+ lib.optionalString stdenv.hostPlatform.isDarwin ''
  #  substituteInPlace firmware/2lib/include/2sysincludes.h \
  #    --replace-fail "<endian.h>" "<machine/endian.h>"
  #'';

  makeFlags = [
    "UB_DIR=$(out)/bin"
    "USE_FLASHROM=0"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "HAVE_MACOS=1" ];

  buildFlags = "futil";

  installTargets = "futil_install";

  meta = {
    homepage = url;
    description = "ChromeOS firmware utility";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "futility";
    badPlatforms = lib.platforms.darwin;
  };
}
