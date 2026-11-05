#!/usr/bin/env -S bash -Eeuo pipefail

# The goal is to embed absolute paths in pkg-config
# files so that packages do not need to be manually placed in
# propagatedBuildInputs and the ref scanner just picks them up.
#
# It then becomes more important that people place these files in
# a dev output in case they are not needed at runtime.
# https://gitlab.freedesktop.org/pkg-config/pkg-config/-/blob/master/pkg.c?ref_type=heads#L239


# Useful info:
#
# Module names == file names with the extension stripped
# pkg-config --variable=pcfiledir = the directory a module is at
# pkg-config --print-requires = newline seperated modules required for dynamic-linking. This includes any version requirements.
# pkg-config --print-requires-private = newline seperated modules required for static linking. This includes any version requirements.
#
# If a module cannot be found with print-requires, pkg-config fails early. This includes
# transitive modules.
pkgConfigFixup() {
  # shellcheck disable=SC2154
  local -r pkg_config_dir="${!outputDev}/lib/pkgconfig"
  if [[ ! -d "$pkg_config_dir" ]]; then
    # If none are installed early return
    return 0
  fi

  # Get all files to process
  local -ra pkg_config_files=( "$pkg_config_dir"/*.pc )

  # The list of dependencies for a given module
  local -a requires requires_private

  local dep_path required regex SEARCH_PATH_orig

  # Save the original one to restore later
  local SEARCH_PATH_orig="$PKG_CONFIG_PATH"

  # Add the current package's output to the search path,
  # as there can be multiple modules that depend on each other
  # like glib
  addToSearchPath "PKG_CONFIG_PATH" "$pkg_config_dir"

  for module in "${pkg_config_files[@]}"; do
    echo "Rewriting pkg-config modules in $module"

    # Gather each module that is in the file (and its transitive deps)
    #
    # If there is a failure, it means a module listed in Requires[.private]
    # cannot be found on the search path.
    mapfile -t requires < <(pkg-config --print-errors --print-requires "$module" || true)
    mapfile -t requires_private < <(pkg-config --print-errors --print-requires-private "$module" || true)

    # Get the path to each module for each dependency, the substitute it into the file
    #
    # Would be good to just fail the build on errors, as the error means
    # the pkg-config module is not in the build closure.
    for required in "${requires[@]}"; do
      echo "Rewriting required module '$required'"
      if [[ "${required%% *}" == "${required#* }" ]]; then
        # Bash does not return an empty string if the char being split at does not exist,
        # it returns the string itself. This works around it.
        dep_path="$(pkg-config --print-errors --variable=pcfiledir "$required" || true)/${required%% *}.pc"
      else
        # Things with 'module >= 1.0' and such
        dep_path="$(pkg-config --print-errors --variable=pcfiledir "$required" || true)/${required%% *}.pc ${required#* }"
      fi

      # Filter to 'Requires:' lines
      # People typo spaces all the time so we must allows multiple spaces and such
      regex="${required// /[[:blank:]]*}"
      sed -i "\|^Requires:| { s|$regex|$dep_path|g; }" "$module"
    done

    for required in "${requires_private[@]}"; do
      echo "Rewriting private module '$required'"
      if [[ "${required%% *}" == "${required#* }" ]]; then
        # Bash does not return an empty string if the char being split at does not exist,
        # it returns the string itself. This works around it.
        dep_path="$(pkg-config --print-errors --variable=pcfiledir "$required" || true)/${required%% *}.pc"
      else
        # Things with 'module >= 1.0' and such
        dep_path="$(pkg-config --print-errors --variable=pcfiledir "$required" || true)/${required%% *}.pc ${required#* }"
      fi

      # Filter to 'Requires.private:' lines
      # People typo spaces all the time so we must allows multiple spaces and such
      regex="${required// /[[:blank:]]*}"
      sed -i "\|^Requires.private:| { s|$regex|$dep_path|g; }" "$module" || true
    done
  done

  export PKG_CONFIG_PATH="$SEARCH_PATH_orig"
}

postFixupHooks+=(pkgConfigFixup)
