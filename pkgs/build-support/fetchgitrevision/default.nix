runCommand: git: repository: branch:
  import (runCommand "head-revision"
    { buildInputs = [ git ];
      dummy = builtins.currentTime;
    }
    ''
      rev=$(git ls-remote ${repository} | grep "refs/${branch}$" | awk '{ print $1 }')
      echo "[ \"$rev\" ]" > $out
      echo Latest revision in ${branch} is $rev
    '')
