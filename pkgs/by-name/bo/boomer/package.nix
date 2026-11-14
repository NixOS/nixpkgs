{
  stdenv,
  lib,
  fetchFromGitHub,
  nim,
  pkg-config,
  makeWrapper,
  wayland,
  wayland-protocols,
  libGL,
  grim,
}:

let
  x11-nim = fetchFromGitHub {
    owner = "nim-lang";
    repo = "x11";
    rev = "1.2";
    sha256 = "sha256-jBNsv8meDvF2ySKewbA+rF2XS+gqydZUl1xhEevD15o=";
  };

  opengl-nim = fetchFromGitHub {
    owner = "nim-lang";
    repo = "opengl";
    rev = "1.2.9";
    sha256 = "sha256-v3bMDobYQZqX0anBFIUfZx5q5/vxTHO6PDtKQlf5mgU=";
  };
in
stdenv.mkDerivation rec {
  pname = "boomer";
  version = "0.0.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cxinu";
    repo = "zoomer";
    rev = "v${version}";
    hash = "sha256-oYDTvqUDw1UwzINQl32xQEUN8anZs3TbJ5qHvgC1k6k=";
  };

  nativeBuildInputs = [
    nim
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libGL
  ];

  buildPhase = ''
    runHook preBuild
    export HOME=$TMPDIR
    nim -p:${x11-nim}/ -p:${opengl-nim}/src -d:release -d:wayland c src/boomer.nim
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin src/boomer
    install -Dm644 LICENSE -t $out/share/licenses/${pname}/
    install -Dm644 README.md -t $out/share/doc/${pname}/
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/boomer \
      --prefix PATH : ${lib.makeBinPath [ grim ]}
  '';

  meta = with lib; {
    description = "A zooming tool for Linux, Wayland port of tsoding's boomer.";
    homepage = "https://github.com/cxinu/zoomer";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cxinu ];
  };
}
