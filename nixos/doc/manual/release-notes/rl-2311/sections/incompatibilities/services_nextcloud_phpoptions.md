- The default priorities of [`services.nextcloud.phpOptions`](#opt-services.nextcloud.phpOptions) have changed. This means that e.g.
  `services.nextcloud.phpOptions."opcache.interned_strings_buffer" = "23";` doesn't discard all of the other defaults from this option
  anymore. The attribute values of `phpOptions` are still defaults, these can be overridden as shown here.

  To override all of the options (including including `upload_max_filesize`, `post_max_size`
  and `memory_limit` which all point to [`services.nextcloud.maxUploadSize`](#opt-services.nextcloud.maxUploadSize)
  by default) can be done like this:

  ```nix
  {
    services.nextcloud.phpOptions = lib.mkForce {
      /* ... */
    };
  }
  ```
