{
  lib,
  stdenv,
  fetchFromGitLab,
  libogg,
  libao,
  autoreconfHook,
  pkg-config,
  flac,
  opusfile,
  libopusenc,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opus-tools";
  version = "0.2";

  src = fetchFromGitLab {
    domain = "gitlab.xiph.org";
    owner = "xiph";
    repo = "opus-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tr+xvZKu1nuachgN7GXwqFyJYPQ/sWqaVJQHWhLAt+k=";
  };
  postPatch = ''
    echo 'PACKAGE_VERSION="${finalAttrs.version}"' > package_version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libogg
    libao
    flac
    opusfile
    libopusenc
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/opusenc";

  meta = {
    description = "Tools to work with opus encoded audio streams";
    homepage = "https://www.opus-codec.org/";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
})
