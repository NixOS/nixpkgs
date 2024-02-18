{ lib, stdenv, bundlerEnv, ruby, fetchFromGitHub }:
let
  version = "1.1";
  gems = bundlerEnv {
    name = "tree-from-tags-${version}-gems";
    inherit ruby;
    gemdir  = ./.;
  };
in stdenv.mkDerivation {
  pname = "tree-from-tags";
  inherit version;
  src = fetchFromGitHub {
    owner  = "dbrock";
    repo   = "bongo";
    rev    = version;
    sha256 = "1nszph9mn98flyhn1jq3y6mdh6jymjkvj5ng36ql016dj92apvhv";
  };
  buildInputs = [ gems ruby ];
  installPhase = ''
    mkdir -p $out/{bin,share}
    cp tree-from-tags.rb $out/share/
    bin=$out/bin/tree-from-tags
# we are using bundle exec to start in the bundled environment
    cat > $bin <<EOF
#!/bin/sh -e
exec ${gems}/bin/bundle exec ${ruby}/bin/ruby "$out"/share/tree-from-tags.rb "\$@"
EOF
    chmod +x $bin
  '';

  meta = with lib; {
    description = "Create file hierarchies from media tags";
    homepage = "https://www.emacswiki.org/emacs/Bongo";
    platforms = ruby.meta.platforms;
    maintainers = [ maintainers.livnev maintainers.dbrock ];
    license = licenses.gpl2Plus;
    mainProgram = "tree-from-tags";
  };
}
