{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "gist";
  version = "6.1.0";
  source.sha256 = "sha256-R76lr4iZJrIN2VvHMnZdAjPZb69ZSj7Nvip4GO9jZdE=";

  meta = {
    description = "Upload code to https://gist.github.com (or github enterprise)";
    homepage = "http://defunkt.io/gist/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zimbatm ];
    platforms = ruby.meta.platforms;
  };
}
