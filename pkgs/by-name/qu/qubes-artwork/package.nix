{
  lib,
  stdenv,
  fetchFromGitHub,
  graphicsmagick,
  inkscape,
  python3,
}:
let
  version = "4.3.2-1";
  src = fetchFromGitHub {
    owner = "QubesOS";
    repo = "qubes-artwork";
    rev = "refs/tags/v${version}";
    hash = "sha256-FIBby9mB/Q6vdGCNJGf17p3ZB7H5Hy4N9XDfaPUEjgs=";
  };

in
stdenv.mkDerivation {
  inherit version src;
  pname = "qubes-artwork";

  postPatch = ''
    substituteInPlace bin/mkpadlock.py \
      --replace-fail "/usr/bin/python3" "${python3.withPackages (p: [p.qubes-imgconverter])}/bin/python3"
  '';

  nativeBuildInputs = [
    graphicsmagick
    inkscape
  ];

  postInstall = ''
    mv $out/usr/* $out/
    rm -d $out/usr
  '';

  makeFlags = [
    "DESTDIR=$(out)"
  ];

  # TODO: Carefully study license. As far as I can see there is no problems with
  # redistribution, but I think to needs what counts as modification here.
  meta = {
    description = "QubesOS icons/wallpapers";
    homepage = "https://qubes-os.org";
    license = with lib.licenses; [ cc-by-nc-sa-40 gpl2Plus ];
    maintainers = with lib.maintainers; [ lach sigmasquadron ];
    platforms = lib.platforms.all;
  };
}
