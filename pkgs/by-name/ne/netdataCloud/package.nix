{
  netdata,
  ...
}@args:

netdata.override (
  {
    withCloudUi = true;
  }
  // removeAttrs args [ "netdata" ]
)
