{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  libxpm,
  libxt,
  withGraphics ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "icon-lang";
  version = "9.5.25a";
  src = fetchFromGitHub {
    owner = "gtownsend";
    repo = "icon";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-COXB03j5keTaRP/ggOU4065NFk3bmK5NTSet4CBGFSM=";
  };

  buildInputs = lib.optionals withGraphics [
    libx11
    libxpm
    libxt
  ];

  configurePhase =
    let
      target = if withGraphics then "X-Configure" else "Configure";
      platform =
        if stdenv.hostPlatform.isLinux then
          "linux"
        else if stdenv.hostPlatform.isDarwin then
          "macintosh"
        else if stdenv.hostPlatform.isBSD then
          "bsd"
        else if stdenv.hostPlatform.isCygwin then
          "cygwin"
        else if stdenv.hostPlatform.isSunOS then
          "solaris"
        else
          throw "unsupported system";
    in
    "make ${target} name=${platform}";

  installPhase = ''
    make Install dest=$out
    rm $out/README
    mkdir -p $out/share/doc
    mv $out/doc $out/share/doc/icon
  '';

  meta = {
    description = "Very high level general-purpose programming language";
    maintainers = with lib.maintainers; [ yurrriq ];
    platforms =
      with lib.platforms;
      linux ++ darwin ++ freebsd ++ netbsd ++ openbsd ++ cygwin ++ illumos;
    license = lib.licenses.publicDomain;
    homepage = "https://www.cs.arizona.edu/icon/";
  };
})
