{
  lib,
  fetchFromGitProvider,
}:

# As fetchFromGitHub is the most widely-used fetcher derived from fetchFromGitProvider,
# fetchFromGitProvider comes with GitHub defaults for performance reasons.
lib.makeOverridable fetchFromGitProvider
