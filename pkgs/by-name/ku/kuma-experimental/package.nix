{
  kuma,
  noMaintainersNorDependents,
  ...
}@args:

noMaintainersNorDependents (
  kuma.override (
    {
      pname = "kuma-experimental";
      isFull = true;
      enableGateway = true;

    }
    // removeAttrs args [
      "kuma"
      "noMaintainersNorDependents"
    ]
  )
)
