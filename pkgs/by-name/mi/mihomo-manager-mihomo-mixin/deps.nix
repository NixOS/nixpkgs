{ fetchNuGet }:
[
  (fetchNuGet {
    pname = "Jint";
    version = "4.9.2";
    sha256 = "hQwVQLZdrwDwwLa7l07GOYmzHDaFiwKW5VIF7XviLR0=";
  })
  (fetchNuGet {
    pname = "SharpYaml";
    version = "3.7.1";
    sha256 = "HXIOrvrhkxNCFjPunOOV/v+F2IVFDJeE5gk+4JPXy2M=";
  })
  (fetchNuGet {
    pname = "acornima";
    version = "1.6.2";
    sha256 = "gDsCbrtcu6rfbEz10iYOOrnfwo1oeH3/HBYmWGeNPVs=";
  })
]
