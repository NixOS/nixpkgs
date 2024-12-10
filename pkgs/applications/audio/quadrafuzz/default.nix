{
  stdenv,
  lib,
  fetchFromGitHub,
  boost,
  cairo,
  lv2,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "quadrafuzz";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kjsf7il9krihwlrq08gk2xvil4b4q5zd87nnm103hby2w7ws7z1";
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

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://github.com/jpcima/quadrafuzz";
    description = "Multi-band fuzz distortion plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
