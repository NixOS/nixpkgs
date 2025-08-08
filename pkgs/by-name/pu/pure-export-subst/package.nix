{
  writeShellApplication,
  jq,
  gitMinimal,

  # for tests
  testers,
  fetchFromGitHub,
  runCommand,
  pure-export-subst,
}:
let
  jqSedGenProg = ''
    {
      H: .sha,
      h: .sha[:7], # we always shorten hashes to the default of 7 characters for reproducibility
      T: .tree.sha,
      t: .tree.sha[:7],
      P: [.parents[] | .sha] | join(" "),
      p: [.parents[] | .sha[:7]] | join(" "),
      an: .author.name,
      ae: .author.email,
      ai: .author.date, # man calls this "ISO 8601-like format", but we just use ISO 8601 provided by GitHub
      aI: .author.date,
      cn: .committer.name,
      ce: .committer.email,
      ci: .committer.date,
      cI: .committer.date,
      d: " (tag: " + $tag + ")",
      D: "tag: " + $tag,
      s: .message | split("\n\n") | .[0],
      b: .message | split("\n\n") | .[1:] | join("\n\n"),
      B: .message,
    }
    # Convert to a list of key-value objects
    | to_entries
    # For each entry generate a command like 's/\$Format:%<key>\$/<value>/g'
    | map("s/\\$Format:%" + .key + "\\$/" + (.value | gsub("/"; "\\/") | gsub("\n"; "\\n")) + "/g")
    # Exit with an error if any unsupported format strings remain
    + ["/\\$Format:%[a-zA-Z]{1,2}\\$/{
      s/.*\\$Format:(%[a-zA-Z]{1,2})\\$.*/Unsupported format string \\1/
      w /dev/stderr
      Q 1
    }"]
    # Join into one big program
    | join("\n")
  '';
in
writeShellApplication {
  name = "pure-export-subst";
  runtimeInputs = [
    jq
    gitMinimal
  ];
  text = ''
    usage() {
      echo "Substitute template strings in current directory like Git's export-subst, but only using provided inputs"
      echo "Usage: pure-export-subst <tag> <commit.json>" >&2
      echo "<tag> is the the tag name to use in substitutions" >&2
      echo "<commit.json> is a file with a JSON representation of a commit in GitHub format" >&2
      echo "See the response format at https://docs.github.com/en/rest/git/commits?apiVersion=2022-11-28#get-a-commit-object" >&2
      exit 1
    }

    if [ $# -ne 2 ]; then
      usage
    fi
    tag="$1"
    commitJSON="$2"
    if [ -z "$tag" ] || [ ! -f "$commitJSON" ]; then
      usage
    fi

    tmpPath="$(realpath "$(mktemp -d --tmpdir pure-export-subst-XXXXXXXX)")"
    cleanup() {
      rm -rf "$tmpPath"
    }
    trap cleanup EXIT

    jq -r -f ${builtins.toFile "prog.jq" jqSedGenProg} --arg tag "$tag" "$commitJSON" > "$tmpPath/sedprog"

    gitDir="$tmpPath/gitrepo"
    git -c advice.defaultBranchName= init --bare "$gitDir"
    find . -type f | \
      git -C "$gitDir" -c core.attributesfile="$PWD/.gitattributes" check-attr --stdin export-subst | \
      (
        set +e
        grep --only-matching --perl-regexp '^.*(?=: .*: set$)'
        rv=$?
        set -e
        # ignore exit code 1 which means that there is no such lines
        if [ $rv != 0 ] && [ $rv != 1 ]; then
          exit $rv
        fi
      ) | \
      xargs --no-run-if-empty sed -i -E -f "$tmpPath/sedprog"
  '';

  passthru.tests =
    let
      doTest =
        {
          name,
          githubArgs,
          outputHash,
          commitJSON,
        }:
        runCommand name
          {
            src = fetchFromGitHub githubArgs;
            nativeBuildInputs = [ pure-export-subst ];
            inherit outputHash;
            outputHashMode = "recursive";
          }
          ''
            cp -r $src source
            chmod -R u+w source
            pushd source
            pure-export-subst "${githubArgs.tag}" "${commitJSON}"
            popd
            mv source $out
          '';
    in
    {
      simple = testers.invalidateFetcherByDrvHash doTest {
        name = "pure-export-subst-simple";
        githubArgs = {
          owner = "smallstep";
          repo = "certificates";
          tag = "v0.28.3";
          hash = "sha256-y5Um8TvtYt1fZU/Jnzt4dE3/M6QUg8k99fXhr71olYU=";
          forceFetchGit = true;
        };
        outputHash = "sha256-5W39Nc6WuxhrXbEfPWMaWWAUX6UnjYqlEAPlDCeYgrY=";
        commitJSON = ./test-v0.28.3.json;
      };
      noop = testers.invalidateFetcherByDrvHash doTest {
        name = "pure-export-subst-noop";
        githubArgs = {
          owner = "smallstep";
          repo = "certificates";
          tag = "v0.8.4"; # They didn't have export-subst at that point
          hash = "sha256-pHs87xXu1ueMMlmUSzrDKYnD1yxpxU2UvOFtjI9ATCw=";
          forceFetchGit = true;
        };
        outputHash = "sha256-pHs87xXu1ueMMlmUSzrDKYnD1yxpxU2UvOFtjI9ATCw=";
        commitJSON = ./test-v0.8.4.json;
      };
    };
}
