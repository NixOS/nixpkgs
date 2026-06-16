{
  linux-router,
  ...
}@args:

linux-router.override (
  {
    useWifiDependencies = false;
  }
  // removeAttrs args [ "linux-router" ]
)
