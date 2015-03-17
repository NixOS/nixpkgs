{ writeTextFile, stdenv, ruby } : { env, runScript } :

let
  name = env.pname;

  # Sandboxing script
  chroot-user = writeTextFile {
    name = "chroot-user";
    executable = true;
    destination = "/bin/chroot-user";
    text = ''
      #! ${ruby}/bin/ruby
      ${builtins.readFile ./chroot-user.rb}
    '';
  };

in stdenv.mkDerivation {
  name = "${name}-userenv";
  buildInputs = [ ruby ];
  preferLocalBuild = true;
  buildCommand = ''
    mkdir -p $out/bin
    cat > $out/bin/${name} <<EOF
    #! ${stdenv.shell}
    exec ${chroot-user}/bin/chroot-user ${env} $out/libexec/run "\$@"
    EOF
    chmod +x $out/bin/${name}

    mkdir -p $out/libexec
    cat > $out/libexec/run <<EOF
    #! ${stdenv.shell}
    source /etc/profile
    ${runScript} "\$@"
    EOF
    chmod +x $out/libexec/run
  '';
}
