runCommand: git: cacert: repository: branch:
  import (runCommand "head-revision"
    { buildInputs = [ git cacert ];
      dummy = builtins.currentTime;
    }
    ''
      rev=$(git -c http.sslCAinfo=${cacert}/etc/ssl/certs/ca-bundle.crt \
                ls-remote ${repository} | \
            egrep "refs(/.*|)/${branch}$" | awk '{ print $1 }')
      echo "[ \"$rev\" ]" > $out
      echo Latest revision in ${branch} is $rev
    '')
