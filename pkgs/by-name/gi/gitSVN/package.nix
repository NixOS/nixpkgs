{ git, ... }@args: git.override ({ svnSupport = true; } // removeAttrs args [ "git" ])
