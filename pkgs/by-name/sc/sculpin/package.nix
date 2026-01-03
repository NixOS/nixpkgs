{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 {
  pname = "sculpin";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "sculpin";
    repo = "sculpin";
    rev = "5f705d845b2dc980ed91b79c49ccaa5f64cbdda0";
    hash = "sha256-R+Msb7dZhdgvL+KROb1y5VdIX4rV8FgyeULOJUfTwOU=";
  };

  vendorHash = "sha256-N9UsSgGjRTrY2S2iUCwtQJbFZfvTod4+HkLjm4nXfJ8=";

  meta = {
    description = "PHP static site generator";
    license = lib.licenses.mit;
    homepage = "https://github.com/sculpin/sculpin";
    maintainers = with lib.maintainers; [ opdavies ];
    platforms = lib.platforms.all;
    mainProgram = "sculpin";
  };
}
