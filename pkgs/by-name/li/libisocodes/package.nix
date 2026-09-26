{
  lib,
  stdenv,
  fetchFromGitHub,
  vala,
  pkg-config,
  gobject-introspection,
  libxml2,
  libgee,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libisocodes";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "toddy15";
    repo = "libisocodes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-a2gVqiZXDiH1byEw/s3MqDQBBZ/bmnw8OyllGYfYykQ=";
  };

  nativeBuildInputs = [
    vala
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    libxml2
    libgee
  ];

  meta = {
    description = "Easily access XML data of the iso-codes package";
    longDescription = ''
      This library can be used to easily access XML data of
      the iso-codes package. It will provide an abstraction
      layer to handle both the version 3 and the upcoming
      version 4 of iso-codes. Moreover, all available
      translations can be used as well.

      This library makes use of the GObject introspection
      features, so that it is accessible from a variety of
      programming languages, for example C, Vala, Ruby,
      Python, Perl, Lua, JavaScript, PHP and many more.
    '';
    homepage = "https://github.com/toddy15/libisocodes";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
