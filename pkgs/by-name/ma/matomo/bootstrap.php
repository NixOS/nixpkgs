<?php
// get PIWIK_USER_PATH from environment variable,
// so this bootstrap.php can be read-only but still configure PIWIK_USER_PATH at runtime
if ($path = getenv('PIWIK_USER_PATH')) {
  define('PIWIK_USER_PATH', $path);
}
