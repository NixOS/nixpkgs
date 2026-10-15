{
  stdenv,
  lib,
  fetchFromGitHub,
  boost,
  cairo,
  lv2,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quadrafuzz";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = "quadrafuzz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4R/NDxd+wQFCtfag9gsmi9C4u5gPAZwphzHPRONxWs4=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    boost
    cairo
    lv2
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/lv2
    cp -r bin/quadrafuzz.lv2/ $out/lib/lv2
    runHook postInstall
  '';

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    homepage = "https://github.com/jpcima/quadrafuzz";
    description = "Multi-band fuzz distortion plugin";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
})
