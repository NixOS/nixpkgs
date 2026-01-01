{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "gist";
  version = "6.0.0";
  source.sha256 = "0qnd1jqd7b04871v4l73grcmi7c0pivm8nsfrqvwivm4n4b3c2hd";

<<<<<<< HEAD
  meta = {
    description = "Upload code to https://gist.github.com (or github enterprise)";
    homepage = "http://defunkt.io/gist/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zimbatm ];
=======
  meta = with lib; {
    description = "Upload code to https://gist.github.com (or github enterprise)";
    homepage = "http://defunkt.io/gist/";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = ruby.meta.platforms;
  };
}
