{
  lib,
  buildRubyGem,
  ruby,
  openssh,
}:

# Example ~/.hss.yml
#---
#patterns:
#  - note: Basic test
#    example: g -> github
#    short: '^g$'
#    long: 'git@github.com'

buildRubyGem rec {
  name = "hss-${version}";
  inherit ruby;
  gemName = "hss";
  version = "1.1.0";
  source.sha256 = "0zfgsiqy2c99c6hlg69bzj83kn6clkw1jmz6n6xh9ap4hz17blgm";

  postInstall = ''
    substituteInPlace $GEM_HOME/gems/${gemName}-${version}/bin/hss \
      --replace-fail \
        "'ssh'" \
        "'${openssh}/bin/ssh'"
  '';

  meta = {
    description = ''
      A SSH helper that uses regex and fancy expansion to dynamically manage SSH shortcuts.
    '';
    homepage = "https://github.com/akerl/hss";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nixy ];
    platforms = lib.platforms.unix;
    mainProgram = "hss";
  };
}
