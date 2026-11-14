{
  lib,
  stdenv,
  fetchFromGitHub,
  puredata,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maxlib";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "electrickery";
    repo = "pd-maxlib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VvcqDE6+RUOTV1KI3ojvxV2pecjC6SnxH5IaYZ/DiYM=";
  };

  buildInputs = [ puredata ];

  hardeningDisable = [ "format" ];

  makeFlags = [ "prefix=$(out)" ];

  postInstall = ''
    mv $out/lib/pd-externals/maxlib/ $out
    rm -rf $out/local/
    rm -rf $out/lib/
  '';

  meta = {
    description = "Library of non-tilde externals for puredata, by Miller Puckette";
    homepage = "http://puredata.info/downloads/maxlib";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
})
