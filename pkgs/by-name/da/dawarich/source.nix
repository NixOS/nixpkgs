# TODO: generate automatically
{
  fetchFromGitHub,
  applyPatches,
  patches ? [ ],
}:
let
  version = "0.29.1";
in
applyPatches {
  src = fetchFromGitHub {
    owner = "Freika";
    repo = "dawarich";
    tag = version;
    hash = "sha256-k8tMw6qAazTSCbQha6GRdca0wwPLQXLUi0+5Eb1HkhE=";

    passthru = {
      inherit version;
      npmHash = "sha256-2PF7OyrKGbLsJ10QzrVNIMZkksHDE7WwJarT7SC/XM0=";
    };
  };
  patches = patches ++ [
    # Upstream is appending `/{number}` to REDIS_URL, but this does not work for unix socket URIs.
    # See https://github.com/redis-rb/redis-client/blob/98a51a42c9952f76238da7f6390315e7d1edb6b3/lib/redis_client/url_config.rb#L30-L42
    # Change the code to use the `db` parameter of the constructor instead, which should work for all URIs.
    # See https://github.com/redis-rb/redis-client/blob/98a51a42c9952f76238da7f6390315e7d1edb6b3/lib/redis_client/config.rb#L198-L201
    # Upstream issue: https://github.com/Freika/dawarich/issues/1507
    ./0001-redis-url-database.diff
  ];
  postPatch = ''
    substituteInPlace ./Gemfile \
      --replace-fail "ruby File.read('.ruby-version').strip" "ruby '>= 3.4.0'"
  '';
}
