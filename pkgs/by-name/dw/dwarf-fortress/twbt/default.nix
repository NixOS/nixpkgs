{
  stdenvNoCC,
  lib,
  fetchurl,
  unzip,
  dfVersion,
}:

let
  inherit (lib)
    getAttr
    hasAttr
    licenses
    maintainers
    platforms
    ;

  twbt-releases = {
    "0.44.12" = {
      twbtRelease = "6.54";
      hash = "sha256-cKomZmTLHab9K8k0pZsB2uMf3D5/SVhy2GRusLdp7oE=";
      prerelease = false;
    };
    "0.47.05" = {
      twbtRelease = "6.xx";
      dfhackRelease = "0.47.05-r8";
      hash = "sha256-qiNs6iMAUNGiq0kpXqEs4u4Wcrjf6/qA/dzBe947Trc=";
      prerelease = false;
    };
  };

  release =
    if hasAttr dfVersion twbt-releases then
      getAttr dfVersion twbt-releases
    else
      throw "[TWBT] Unsupported Dwarf Fortress version: ${dfVersion}";
in

stdenvNoCC.mkDerivation rec {
  pname = "twbt";
  version = release.twbtRelease;

  src = fetchurl {
    url =
      if version == "6.xx" then
        "https://github.com/thurin/df-twbt/releases/download/${release.dfhackRelease}/twbt-${version}-linux64-${release.dfhackRelease}.zip"
      else
        "https://github.com/mifki/df-twbt/releases/download/v${version}/twbt-${version}-linux.zip";
    inherit (release) hash;
  };

  sourceRoot = ".";

  outputs = [
    "lib"
    "art"
    "out"
  ];

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $lib/hack/{plugins,lua} $art/data/art
    cp -a */twbt.plug.so $lib/hack/plugins/
    cp -a *.lua $lib/hack/lua/
    cp -a *.png $art/data/art/
  '';

  passthru = {
    inherit dfVersion;
  };

  meta = {
    description = "Plugin for Dwarf Fortress / DFHack that improves various aspects of the game interface";
    maintainers = with maintainers; [
      Baughn
      numinit
    ];
    license = licenses.mit;
    platforms = platforms.linux;
    homepage = "https://github.com/mifki/df-twbt";
  };
}
