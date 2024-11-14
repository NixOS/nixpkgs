{ lib }:
# We provide three paths to get the credentials into the builder's
# environment:
#
# 1. Via impureEnvVars. This method is difficult for multi-user Nix
#    installations (but works very well for single-user Nix
#    installations!) because it requires setting the environment
#    variables on the nix-daemon which is either complicated or unsafe
#    (i.e: configuring via Nix means the secrets will be persisted
#    into the store)
#
# 2. If the DOCKER_CREDENTIALS key with a path to a credentials file
#    is added to the NIX_PATH (usually via the '-I ' argument to most
#    Nix tools) then an attempt will be made to read credentials from
#    it. The semantics are simple, the file should contain two lines
#    for the username and password based authentication:
#
# $ cat ./credentials-file.txt
# DOCKER_USER=myusername
# DOCKER_PASS=mypassword
#
#    ... and a single line for the token based authentication:
#
# $ cat ./credentials-file.txt
# DOCKER_TOKEN=mytoken
#
# 3. A credential file at /etc/nix-docker-credentials.txt with the
#    same format as the file described in #2 can also be used to
#    communicate credentials to the builder. This is necessary for
#    situations (like Hydra) where you cannot customize the NIX_PATH
#    given to the nix-build invocation to provide it with the
#    DOCKER_CREDENTIALS path
let
  pathParts =
   (builtins.filter
    ({prefix, path}: "DOCKER_CREDENTIALS" == prefix)
    builtins.nixPath);
in
  lib.optionalString (pathParts != []) ((builtins.head pathParts).path)
