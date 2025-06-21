{
  lib,
  fetchzip,
  jre,
  makeWrapper,
  maven,
  openjdk17,
  jdk ? openjdk17,
  unzip,
  swt,
  glib,
}:

let
  version = "2.14.0";
  swtPkg = swt.override { jdk = jdk; };
  swtLibDir = lib.getLib swtPkg + "/lib";
  glibLibDir = lib.getLib glib + "/lib";
  hopDir = "$out/share/apache-hop";

  # For being able to set $HOP_AUDIT_FOLDER and $HOP_CONFIG_FOLDER
  # to user-dependant values (e.g. to paths in their $HOME)
  # we have to do variable expansion at wrapper script runtime.
  # That's why we set them in `--run` rather than with `--set`.
  wrapHopTool = toolName: ''
    set -u
    makeWrapper "${hopDir}/hop/${toolName}.sh" "$out/bin/${toolName}" \
      --run '# Set script to abort when any variable is used without fallback without being set:
             set -u

             # Set the library search path, so that SWT and GLib will be found:
             export LD_LIBRARY_PATH="''${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}${swtLibDir}:${glibLibDir}"

             # Set up the below directory paths relative to $XDG_CONFIG_HOME
             # but fall back to ~/.config if the former is not set:
             XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"

             # At runtime, Apache Hop stores some data.
             # By default, it would do so at at subdirs of where the contents
             # of hop-client-${version}.zip were unpacked,
             # thus in our case at "'${hopDir}'/hop/…", which is not user-writable.
             # We override this behavior by setting environment variables
             # (see <https://hop.apache.org/manual/'${version}'/variables.html#_environment_variables_2>)
             # and by running hop-conf
             # (see <https://hop.apache.org/manual/'${version}'/hop-tools/hop-conf/hop-conf.html>).

             # If not set …
             if [[ ! -v HOP_AUDIT_FOLDER ]]; then
               # Set where Hop stores "audit information"
               # (includes last opened files per project, zoom size):
               export HOP_AUDIT_FOLDER="$XDG_CONFIG_HOME/apache-hop/audit"
               # Create that directory, if it does not exist yet:
               mkdir -p "$HOP_AUDIT_FOLDER"
             fi

             # If not set …
             if [[ ! -v HOP_CONFIG_FOLDER ]]; then
               # Set where Hop stores configuration:
               export HOP_CONFIG_FOLDER="$XDG_CONFIG_HOME/apache-hop/config"
               # Create the parent of that dir, if it does not exist yet:
               mkdir -p "$(dirname "$HOP_CONFIG_FOLDER")"

               # If the config dir itself does not exist yet, …
               if [ ! -d "$HOP_CONFIG_FOLDER" ]; then
                 # … create and populate it by copying the default initial contents:
                 cp -na --no-preserve=ownership "'${hopDir}'/hop/config/" "$HOP_CONFIG_FOLDER"

                 # … and make them user-writable:
                 chmod u+w "$HOP_CONFIG_FOLDER" -R

                 # … and then run hop-conf to set the standard projects directory
                 # (used e.g. as initial position of the directory chooser dialog
                 # when creating a project),
                 # to be subdir projects/ of the config directory
                 # as the former would otherwise still default to
                 # "'${hopDir}'/hop/config/projects/",
                 # which is of course also not user-writable:
                 "'"$out"'/bin/hop-conf" --standard-projects-folder "$HOP_CONFIG_FOLDER/projects"
               fi
             fi' \
      --set HOP_JAVA_HOME "${jre}"
  '';
  hopTools = [
    "hop-conf"
    "hop-encrypt"
    "hop-gui"
    "hop-import"
    "hop-run"
    "hop-search"
    "hop-server"
  ];
in
maven.buildMavenPackage rec {
  pname = "apache-hop";
  inherit version;

  src = fetchzip {
    url = "https://www.apache.org/dyn/closer.cgi?filename=hop/${version}/apache-hop-${version}-src.tar.gz&action=download";
    hash = "sha256-PbzNydiaX6GXdShJjpPi8Bxh1USZzHi4Uul7w9uXaJg=";
  };

  mvnHash = "sha256-X/dx8K8vzph69TszhSUMiTBAEqikHG4t0S7q55UaRhE=";
  mvnJdk = jdk;
  doCheck = false;

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];
  buildInputs = [
    swtPkg
    glib
  ];

  installPhase = ''
    mkdir -p $out/bin ${hopDir}
    unzip assemblies/client/target/hop-client-${version}.zip -d ${hopDir}

    ${lib.concatMapStringsSep "\n" wrapHopTool hopTools}
  '';

  meta = {
    description = "A data integration platform";
    homepage = "https://hop.apache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ das-g ];
  };
}
