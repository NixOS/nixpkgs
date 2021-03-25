{ stdenv, lib, rel, addonDir, buildKodiBinaryAddon, fetchFromGitHub, expat, glib, nspr, nss }:
buildKodiBinaryAddon rec {
  pname = "inputstream-adaptive";
  namespace = "inputstream.adaptive";
  version = "2.6.7";

  src = fetchFromGitHub {
    owner = "peak3d";
    repo = "inputstream.adaptive";
    rev = "${version}-${rel}";
    sha256 = "1pwqmbr78wp12jn6rwv63npdfc456adwz0amlxf6gvgg43li6p7s";
  };

  extraBuildInputs = [ expat ];

  extraRuntimeDependencies = [ glib nspr nss stdenv.cc.cc.lib ];

  extraInstallPhase = let n = namespace; in ''
    ln -s $out/lib/addons/${n}/libssd_wv.so $out/${addonDir}/${n}/libssd_wv.so
  '';

  meta = with lib; {
    homepage = "https://github.com/peak3d/inputstream.adaptive";
    description = "Kodi inputstream addon for several manifest types";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
