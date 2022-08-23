# Parse go.mod in Nix
# Returns a Nix structure with the contents of the go.mod passed in
# in normalised form.

let
  inherit (builtins) elemAt mapAttrs split foldl' match filter typeOf hasAttr length;

  # Strip lines with comments & other junk
  stripStr = s: elemAt (split "^ *" (elemAt (split " *$" s) 0)) 2;
  stripLines = initialLines: foldl' (acc: f: f acc) initialLines [
    # Strip comments
    (lines: map
      (l: stripStr (elemAt (splitString "//" l) 0))
      lines)

    # Strip leading tabs characters
    (lines: map (l: elemAt (match "(\t)?(.*)" l) 1) lines)

    # Filter empty lines
    (filter (l: l != ""))
  ];

  # Parse lines into a structure
  parseLines = lines: (foldl'
    (acc: l:
      let
        m = match "([^ )]*) *(.*)" l; # Match the current line
        directive = elemAt m 0; # The directive (replace, require & so on)
        rest = elemAt m 1; # The rest of the current line

        # Maintain parser state (inside parens or not)
        inDirective =
          if rest == "(" then directive
          else if rest == ")" then null
          else acc.inDirective
        ;

      in
      {
        data = (acc.data // (
          # If a we're in a directive and it's closing, no-op
          if directive == "" && rest == ")" then { }

          # If a directive is opening create the directive attrset
          else if inDirective != null && rest == "(" && ! hasAttr inDirective acc.data then {
            ${inDirective} = { };
          }

          # If we're closing any paren, no-op
          else if rest == "(" || rest == ")" then { }

          # If we're in a directive that has rest data assign it to the directive in the output
          else if inDirective != null then {
            ${inDirective} = acc.data.${inDirective} // { ${directive} = rest; };
          }

          # Replace directive has unique structure and needs special casing
          else if directive == "replace" then
            (
              let
                # Split `foo => bar` into segments
                segments = split " => " rest;
                getSegment = elemAt segments;
              in
              assert length segments == 3; {
                # Assert well formed
                replace = acc.data.replace // {
                  # Structure segments into attrset
                  ${getSegment 0} = "=> ${getSegment 2}";
                };
              }
            )

          # The default operation is to just assign the value
          else {
            ${directive} = rest;
          }
        )
        );
        inherit inDirective;
      })
    {
      # Default foldl' state
      inDirective = null;
      # The actual return data we're interested in (default empty structure)
      data = {
        require = { };
        replace = { };
        exclude = { };
      };
    }
    lines
  ).data;

  # Normalise directives no matter what syntax produced them
  # meaning that:
  # replace github.com/nix-community/trustix/packages/go-lib => ../go-lib
  #
  # and:
  # replace (
  #     github.com/nix-community/trustix/packages/go-lib => ../go-lib
  # )
  #
  # gets the same structural representation.
  #
  # Addtionally this will create directives that are entirely missing from go.mod
  # as an empty attrset so it's output is more consistent.
  normaliseDirectives = data: (
    let
      normaliseString = s:
        let
          m = builtins.match "([^ ]+) (.+)" s;
        in
        {
          ${elemAt m 0} = elemAt m 1;
        };
      require = data.require or { };
      replace = data.replace or { };
      exclude = data.exclude or { };
    in
    data // {
      require =
        if typeOf require == "string" then normaliseString require
        else require;
      replace =
        if typeOf replace == "string" then normaliseString replace
        else replace;
    }
  );

  # Parse versions and dates from go.mod version string
  parseVersion = ver:
    let
      m = elemAt (match "([^-]+)-?([^-]*)-?([^-]*)" ver);
      v = elemAt (match "([^+]+)\\+?(.*)" (m 0));
    in
    {
      version = v 0;
      versionSuffix = v 1;
      date = m 1;
      rev = m 2;
    };

  # Parse package paths & versions from replace directives
  parseReplace = data: (
    data // {
      replace =
        mapAttrs
          (_: v:
            let
              m = match "=> ([^ ]+) (.+)" v;
              m2 = match "=> ([^ ]+)" v;
            in
            if m != null then {
              goPackagePath = elemAt m 0;
              version = elemAt m 1;
            } else {
              path = elemAt m2 0;
            })
          data.replace;
    }
  );

  splitString = sep: s: filter (t: t != [ ]) (split sep s);

in
contents:
foldl' (acc: f: f acc) (splitString "\n" contents) [
  stripLines
  parseLines
  normaliseDirectives
  parseReplace
]
