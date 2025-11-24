{
  lib,
  qt6,
  zlib,
  cmake,
  efivar,
  pkg-config,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "efibooteditor";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "Neverous";
    repo = "efibooteditor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xD40ZzkpwerDYC8nzGVqEHLV0KWbxcc0ApquQjrPJTc=";
  };

  buildInputs = [ zlib ] ++ lib.optional stdenv.hostPlatform.isLinux efivar;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  postPatch = ''
    substituteInPlace misc/org.x.efibooteditor.policy \
      --replace-fail /usr/bin $out/bin
    substituteInPlace misc/EFIBootEditor.desktop \
      --replace-fail "1.0" ${finalAttrs.version} \
      --replace-fail \
        'pkexec efibooteditor' \
        'sh -c "pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY efibooteditor"'
  '';

  env.BUILD_VERSION = "v${finalAttrs.version}";
  cmakeBuildType = "MinSizeRel";
  cmakeFlags = [ "-DQT_VERSION_MAJOR=6" ];

  postInstall = ''
    install -Dm644 $src/LICENSE.txt $out/share/licenses/efibooteditor/LICENSE
  '';

  meta = {
    description = "Boot Editor for (U)EFI based systems";
    homepage = "https://github.com/Neverous/efibooteditor";
    changelog = "https://github.com/Neverous/efibooteditor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux; # TODO build is broken on darwin
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "efibooteditor";
  };
})
