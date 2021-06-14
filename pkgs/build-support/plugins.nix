{ lib }:
# helper functions for packaging programs with plugin systems
{

  /* Takes a list of expected plugin names
   * and compares it to the found plugins given in the file,
   * one plugin per line.
   * If the lists differ, the build fails with a nice message.
   *
   * This is helpful to ensure maintainers don’t miss
   * the addition or removal of a plugin.
   */
  diffPlugins = expectedPlugins: foundPluginsFilePath: ''
     # sort both lists first
     plugins_expected=$(mktemp)
     (${lib.concatMapStrings (s: "echo \"${s}\";") expectedPlugins}) \
       | sort -u > "$plugins_expected"
     plugins_found=$(mktemp)
     sort -u "${foundPluginsFilePath}" > "$plugins_found"

     if ! mismatches="$(diff -y "$plugins_expected" "$plugins_found")"; then
       echo "The the list of expected plugins (left side) doesn't match" \
           "the list of plugins we found (right side):" >&2
       echo "$mismatches" >&2
       exit 1
     fi
   '';

}
