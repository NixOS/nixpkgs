{ stdenv, rustPlatform, fetchFromGitHub, libX11, libXcursor, libXrandr, libXi, libGL, patchelf }:

let
  rpath = [ libX11 libXcursor libXrandr libXi libGL ];
in

rustPlatform.buildRustPackage rec {
  pname = "emulsion";
  version = "v5.0";

  src = fetchFromGitHub {
    owner = "ArturKovacs";
    repo = pname;
    rev = version;
    sha256 = "sha256-AGSki0eMWCUgnG7AK2y6+3uJE1F9nqLGIO4rABr1nxI=";
  };

  cargoSha256 = "sha256-9f6imRK+UtblayDRFPra23xTh2hLRVE2WlBOkuvjZxk=";

  buildInputs = rpath;
  nativeBuildInputs = [ patchelf ];

  postFixup = ''
      patchelf --set-rpath "${stdenv.lib.makeLibraryPath rpath}" $out/bin/emulsion
  '';

  meta = with stdenv.lib; {
    description = "A fast and minimalistic image viewer";
    homepage = "https://github.com/ArturKovacs/emulsion";
    license = licenses.mit;
    maintainers = with maintainers; [ TethysSvensson ];
    platforms = platforms.unix;
  };
}
