{
  setup-helper = {
    preBuild = ''
      substituteInPlace setup-helper.setup \
        --replace "(chicken-home)" \"$out/share/\"

        cat setup-helper.setup
    '';
  };
}
