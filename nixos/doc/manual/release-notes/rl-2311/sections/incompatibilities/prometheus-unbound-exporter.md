- `prometheus-unbound-exporter` has been replaced by the Let's Encrypt maintained version, since the previous version was archived. This requires some changes to the module configuration, most notable `controlInterface` needs migration
   towards `unbound.host` and requires either the `tcp://` or `unix://` URI scheme.
