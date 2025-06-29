{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  lib3mf,
  openscad,
  openscad-package ? openscad,
  makeWrapper,
  zip,
}:
stdenv.mkDerivation rec {
  pname = "colorscad";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "jschobben";
    repo = "colorscad";
    rev = "v${version}";
    hash = "sha256-GnSSHmXws7d/uLCJMV17xfZ5Uzcfcmr8U4PHQEqJLdk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    lib3mf
  ];

  postInstall = ''
    # Runtime dependencies for the `colorscad` script.
    wrapProgram $out/bin/colorscad \
      --prefix PATH : "${lib.makeBinPath [openscad-package]}:$out/bin"
  '';

  meta = with lib; {
    description = "Export OpenSCAD models to AMF or 3MF with preserved colors";
    homepage = "https://github.com/jschobben/colorscad";
    license = licenses.mit;
    maintainers = with maintainers; ["knoc-off"];
    platforms = platforms.all;
    mainProgram = "colorscad";
  };
}
