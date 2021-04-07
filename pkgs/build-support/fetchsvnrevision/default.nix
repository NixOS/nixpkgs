runCommand: subversion: repository:
  import (runCommand "head-revision"
    { buildInputs = [ subversion ];
      dummy = builtins.currentTime;
    }
    ''
      rev=$(echo p | svn ls -v --depth empty  ${repository} |awk '{ print $1 }')
      echo "[ \"$rev\" ]" > $out
      echo Latest revision is $rev
    '')
