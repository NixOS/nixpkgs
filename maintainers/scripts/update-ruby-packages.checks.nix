{
  old,
  new,
  specifiedGems,
  withData ? false,
  # Use for `lib`.
  pkgs ? import ../.. { },
}:

# Rename inputs to re-use those names.
let
  old' = old;
  new' = new;
  specifiedGems' = specifiedGems;
in

let
  inherit (builtins)
    attrNames
    concatStrings
    filter
    genList
    isNull
    length
    stringLength
    toJSON
    ;
  inherit (pkgs.lib)
    concatMapStringsSep
    concatStringsSep
    intersectLists
    splitString
    subtractLists
    versionOlder
    ;

  # Keeps non-nulls in a list.
  # Mirroring Ruby's `Array#compact`.
  compact = filter (v: !(isNull v));

  # The full gemsets attribute sets.
  old = import old';
  new = import new';

  # All gem names.
  allGems = attrNames (old // new);

  # Gems found in both old and new.
  keptGems = intersectLists (attrNames old) (attrNames new);

  # Gems added or removed.
  addedOrRemovedGems = subtractLists keptGems allGems;

  # Gems specified in Gemfile.
  specifiedGems = splitString "\n" specifiedGems';

  # Gems that were not specified.
  nonSpecifiedGems = subtractLists specifiedGems keptGems;

  # Generates data for the summary tables
  # This is also used for `failedChecks`.
  versionChangeDataFor =
    gems:
    let
      results = map (
        name:
        let
          oldv = old.${name}.version or null;
          newv = new.${name}.version or null;
        in
        if newv == oldv then
          # Nothing changed. This will be filtered out.
          null
        else
          {
            inherit
              name
              ;
            old = oldv;
            new = newv;
          }
      ) gems;
    in
    compact results;

  checkRegression =
    entry: message:
    let
      isRemoval = isNull entry.new;
      isAddition = isNull entry.old;
      isRegression = versionOlder entry.new entry.old;
    in
    if
      # Gems being added or gems being removed won't cause failures.
      !isRemoval
      && !isAddition
      # A version being regressed is a failure.
      && isRegression
    then
      message
    else
      null;

  # This is a list of error messages to float up to the user.
  # An empty list means no error.
  failedChecks = compact (
    [ ]
    ++ (map (
      entry:
      checkRegression entry "Version regression for specified gem ${toJSON entry.name}, from ${toJSON entry.old} to ${toJSON entry.new}"
    ) (versionChangeDataFor specifiedGems))
    ++ (map (
      entry:
      checkRegression entry "Version regression for non-specified gem ${toJSON entry.name}, from ${toJSON entry.old} to ${toJSON entry.new}"
    ) (versionChangeDataFor nonSpecifiedGems))
  );

  # Formats a version number (or null) as markdown.
  gemVersionToMD = version: if isNull version then "*N/A*" else "`${version}`";

  # Formats a `versionChangeDataFor` output as markdown.
  versionChangeDataMD =
    gems:
    let
      result = versionChangeDataFor gems;
    in
    map (
      row:
      [ row.name ]
      ++ (map gemVersionToMD [
        row.old
        row.new
      ])
    ) result;

  # Given a list of columns, and a list of list of column data,
  # generates the markup for markdown table.
  mkTable =
    columns: entries:
    let
      entryToMarkdown = columns: "| ${concatStringsSep " | " columns} |";
      sep = entryToMarkdown (map (_: "---") columns);
    in
    if length entries == 0 then
      "> *No data...*"
    else
      ''
        ${entryToMarkdown columns}
        ${sep}
        ${concatMapStringsSep "\n" entryToMarkdown entries}
      '';

  # The markdown report is built as this string.
  report = ''
    <!--
    ----------------------------------------------
    NOTE: You must copy this whole report section
          to your pull request!
    ----------------------------------------------
    -->

    #### Nixpkgs Ruby packages update report

    **Specified gems changed:**

    ${mkTable [ "Name" "old" "new" ] (versionChangeDataMD specifiedGems)}

    **Gems added or removed:**

    ${mkTable [ "Name" "old" "new" ] (versionChangeDataMD addedOrRemovedGems)}

    <details>

    <summary><strong>(Non-specified gem changes)</strong></summary>

    ${mkTable [ "Name" "old" "new" ] (versionChangeDataMD nonSpecifiedGems)}

    </details>

    <!-- --------------- End ----------------- -->
  '';
in
if (length failedChecks) > 0 then
  # Fail the update script via `abort` on checks failure.
  builtins.abort ''
    ${"\n"}Gem upgrade aborted with the following failures:

    ${concatMapStringsSep "\n" (msg: " - ${msg}") failedChecks}
  ''
else
  # Output the report.
  builtins.trace "(Report follows...)\n\n${report}" (
    # And if `withData` is true, expose the data for REPL usage.
    if withData then
      {
        inherit
          # The gemsets used
          old
          new
          # The lists of gems
          allGems
          specifiedGems
          nonSpecifiedGems
          addedOrRemovedGems
          keptGems
          ;
      }
    else
      null
  )
