{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  rizin,
  openssl,
}:

let
  version = "0.9.0";

  libquickjs = fetchFromGitHub {
    owner = "quickjs-ng";
    repo = "quickjs";
    tag = "v${version}";
    hash = "sha256-o0Cpy+20EqNdNENaYlasJcKIGU7W4RYBcTMsQwFTUNc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "jsdec";
  version = version;

  src = fetchFromGitHub {
    owner = "rizinorg";
    repo = "jsdec";
    rev = "v${version}";
    hash = "sha256-9FNsFPQf3GyREXsagWDHctfne28lct6dPH8vKvF8kpY=";
  };

  postUnpack = ''
    cp -r --no-preserve=mode ${libquickjs} $sourceRoot/subprojects/libquickjs
  '';

  postPatch = ''
    cp subprojects/packagefiles/libquickjs/* subprojects/libquickjs
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    openssl
    rizin
  ];

  meta = {
    description = "Simple decompiler for Rizin";
    homepage = finalAttrs.src.meta.homepage;
    changelog = "${finalAttrs.src.meta.homepage}/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [
      asl20
      bsd3
      mit
    ];
    maintainers = with lib.maintainers; [ chayleaf ];
  };
})
