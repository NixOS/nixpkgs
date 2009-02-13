args:
args.stdenv.mkDerivation {
  name = "thinkingrock-2.0.1-binary";

  src = args.fetchurl {
    url = mirror://sourceforge/thinkingrock/tr-2.0.1.tar.gz;
    sha256 = "1fsanxh0li8yqsspagx1w1ykmvfnm6h44i6gd02v05abx8q25jk1";
  };

  /* it would be a really bad idea to put thinkingrock tr executable in PATH!
     the tr.sh script does use the coreutils tr itself
     That's why I've renamed the wrapper and called it thinkingrock
     However you may not rename the bin/tr script cause it will notice and throw an 
     "java.lang.IllegalArgumentException: Malformed branding token: thinkingrock"
     exception. I hope that's fine
  */

  buildPhase = ''
    # only keep /bin/tr
    ls -1 bin/* | grep -ve  'bin/tr''$' | xargs rm
    # don't keep the other .exe file either
    find . -iname "*.exe" | xargs -n1 rm
    ensureDir $out/{nix-support/tr-files,bin}
    cp -r . $out/nix-support/tr-files
    cat >> $out/bin/thinkingrock << EOF
    #!/bin/sh
    exec $out/nix-support/tr-files/bin/tr "$@"
    EOF
    chmod +x $out/bin/thinkingrock
  '';
  installPhase = ":";

  meta = { 
      description = "task managing system";
      homepage = http://www.thinkingrock.com.au/;
      license = "CDDL"; # Common Development and Distribution License
  };
}
