{ # locateDominatingFile :  RegExp
  #                      -> Path
  #                      -> Nullable { path : Path;
  #                                    matches : [ MatchResults ];
  #                                  }
  # Find the first directory containing a file matching 'pattern'
  # upward from a given 'file'.
  # Returns 'null' if no directories contain a file matching 'pattern'.
  locateDominatingFile = pattern: file:
    let go = path:
          let files = builtins.attrNames (builtins.readDir path);
              matches = builtins.filter (match: match != null)
                          (map (builtins.match pattern) files);
          in
            if builtins.length matches != 0
              then { inherit path matches; }
              else if path == /.
                then null
                else go (dirOf path);
        parent = dirOf file;
        isDir =
          let base = baseNameOf file;
              type = (builtins.readDir parent).${base} or null;
          in file == /. || type == "directory";
    in go (if isDir then file else parent);
}
