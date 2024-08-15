{ stdenv
, fetchzip
, python3Packages
, makeWrapper
, patch
}:

{ rev
, hash
}:

stdenv.mkDerivation {
  pname = "ungoogled-chromium";

  version = rev;

  src = fetchzip {
    urls = [
      "https://github.com/ungoogled-software/ungoogled-chromium/archive/${rev}.tar.gz"
      "https://codeberg.org/ungoogled-software/ungoogled-chromium/archive/${rev}.tar.gz"
    ];
    inherit hash;
  };

  dontBuild = true;

  buildInputs = [
    python3Packages.python
    patch
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  patchPhase = ''
    sed -i '/chromium-widevine/d' patches/series
  '';

  installPhase = ''
    mkdir $out
    cp -R * $out/
    wrapProgram $out/utils/patches.py --add-flags "apply" --prefix PATH : "${patch}/bin"
  '';
}
