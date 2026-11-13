{
  autoreconfHook,
  dejagnu,
  fetchFromGitHub,
  fetchpatch2,
  help2man,
  lib,
  nix-update-script,
  pkg-config,
  pkgConfigCheckHook,
  stdenv,
  versionCheckHook,
}:
let
  inherit (lib.lists) optional;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mp4v2";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "mp4v2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PzpfhufpOcnJhqbDw/pJb26dBlXb/Ojvdx7LicLHtZk=";
  };

  patches = [
    (fetchpatch2 {
      name = "CVE-2023-33716+CVE-2023-33720.patch";
      url = "https://github.com/enzo1982/mp4v2/commit/0f97a87685c8fcf9d7b9b21167265b21b1c34cc5.patch?full_index=1";
      hash = "sha256-n2yt+zmHsWOSVPwrCJY67yKATISSPULKehzxo7FFwWY=";
    })
    (fetchpatch2 {
      name = "CVE-2023-33717+CVE-2023-33718+CVE-2023-33719.patch";
      url = "https://github.com/enzo1982/mp4v2/commit/c724815a541b763455ff38922af96f652627bce6.patch?full_index=1";
      hash = "sha256-8l+TAHUWvWTa9fe0Vfy8g/7X4JTpdvT711UAfaOzIyY=";
    })
  ];

  outputs = [
    "out"
    "dev"
    "lib"
  ]
  ++ optional (stdenv.buildPlatform.canExecute stdenv.hostPlatform) "man";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ optional (stdenv.buildPlatform.canExecute stdenv.hostPlatform) help2man;

  makeFlags = optional (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) "man1_MANS=";

  enableParallelBuilding = true;

  doCheck = true;
  nativeCheckInputs = [ dejagnu ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    pkgConfigCheckHook
    versionCheckHook
  ];
  pkgConfigModules = [ "mp4v2" ];
  versionCheckProgram = "${placeholder "out"}/bin/mp4file";

  passthru.updateScript = nix-update-script { };

  meta = {
    inherit (finalAttrs) pkgConfigModules;
    changelog = "https://github.com/enzo1982/mp4v2/releases/tag/${finalAttrs.src.tag}";
    description = "Library and tools to read, create, and modify MP4 files";
    longDescription = ''
      The MP4v2 library provides an API to create and modify MP4 files as
      defined by ISO-IEC:14496-1:2001 MPEG-4 Systems. This file format is
      derived from Apple's QuickTime file format that has been used as a
      multimedia file format in a variety of platforms and applications. It
      is a very powerful and extensible format that can accommodate
      practically any type of media.
    '';
    homepage = "https://mp4v2.org";
    license = lib.licenses.mpl11;
    maintainers = with lib.maintainers; [
      Anton-Latukha
      connor-grady
    ];
    platforms = lib.platforms.unix;
  };
})
