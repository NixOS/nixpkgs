{
  docker,
  ...
}@args:

docker.override (
  {
    clientOnly = true;
  }
  // removeAttrs args [ "docker" ]
)
