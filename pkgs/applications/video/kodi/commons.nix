{ stdenv, fetchurl, fetchFromGitHub, fetchpatch, lib
, unzip, cmake, kodiPlain, steam, libcec_platform, tinyxml
, libusb, pcre-cpp, jsoncpp, libhdhomerun }:

rec {

  pluginDir = "/share/kodi/addons";

  kodi-platform = stdenv.mkDerivation rec {
    project = "kodi-platform";
    version = "17.1";
    name = "${project}-${version}";

    src = fetchFromGitHub {
      owner = "xbmc";
      repo = project;
      rev = "c8188d82678fec6b784597db69a68e74ff4986b5";
      sha256 = "1r3gs3c6zczmm66qcxh9mr306clwb3p7ykzb70r3jv5jqggiz199";
    };

    buildInputs = [ cmake kodiPlain libcec_platform tinyxml ];

  };

  mkKodiAPIPlugin = { plugin, namespace, version, src, meta, sourceDir ? null, ... }:
  stdenv.lib.makeOverridable stdenv.mkDerivation rec {

    inherit src meta sourceDir;

    name = "kodi-plugin-${plugin}-${version}";

    passthru = {
      kodiPlugin = pluginDir;
      namespace = namespace;
    };

    dontStrip = true;

    installPhase = ''
      ${if isNull sourceDir then "" else "cd $src/$sourceDir"}
      d=$out${pluginDir}/${namespace}
      mkdir -p $d
      sauce="."
      [ -d ${namespace} ] && sauce=${namespace}
      cp -R "$sauce/"* $d
    '';

  };

  mkKodiPlugin = mkKodiAPIPlugin;

  mkKodiABIPlugin = { plugin, namespace, version, src, meta
                    , extraBuildInputs ? [], sourceDir ? null, ... }:
  stdenv.lib.makeOverridable stdenv.mkDerivation rec {

    inherit src meta sourceDir;

    name = "kodi-plugin-${plugin}-${version}";

    passthru = {
      kodiPlugin = pluginDir;
      namespace = namespace;
    };

    dontStrip = true;

    buildInputs = [ cmake kodiPlain kodi-platform libcec_platform ]
               ++ extraBuildInputs;

    # disables check ensuring install prefix is that of kodi
    cmakeFlags = [
      "-DOVERRIDE_PATHS=1"
    ];

    # kodi checks for plugin .so libs existance in the addon folder (share/...)
    # and the non-wrapped kodi lib/... folder before even trying to dlopen
    # them. Symlinking .so, as setting LD_LIBRARY_PATH is of no use
    installPhase = let n = namespace; in ''
      make install
      ln -s $out/lib/addons/${n}/${n}.so.${version} $out/${pluginDir}/${n}.so
    '';

  };
}
