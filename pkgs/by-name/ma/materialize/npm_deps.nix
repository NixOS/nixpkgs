# materialized doesn't use npm to pull in its few node dependencies but instead
# manually pulls the tar archives for each package and pulls out a couple of
# files.
#
# The list of modules can be found in this file
# https://github.com/MaterializeInc/materialize/blob/master/src/npm/lib.rs
[
  {
    name = "@hpcc-js/wasm";
    version = "0.3.14";
    hash = "sha256-EsbuFk9qtlm9yWpG29RnqVAHrP0rk3xyibQLy8qgRT4=";
    js_prod_file = "dist/index.min.js";
    js_dev_file = "dist/index.js";
    extra_file = {
      src = "dist/graphvizlib.wasm";
      dst = "js/vendor/@hpcc-js/graphvizlib.wasm";
    };
  }
  {
    name = "@babel/standalone";
    version = "7.23.3";
    hash = "sha256-yxhB4OVOdV8hYNPqcap+5/JXYeaVrNGOSOG8lKpiG9E=";
    js_prod_file = "babel.min.js";
    js_dev_file = "babel.js";
  }
  {
    name = "d3";
    version = "5.16.0";
    hash = "sha256-aQQRhnJxV5/9C+cQslctP3v/AePGfbSw8L3chObJzK4=";
    js_prod_file = "dist/d3.min.js";
    js_dev_file = "dist/d3.js";
  }
  {
    name = "d3-flame-graph";
    version = "3.1.1";
    hash = "sha256-Ls3MqALr6+/A+n8jqFw7frIB++6d1W3lAXKU0qFZ2ok=";
    css_file = "dist/d3-flamegraph.css";
    js_prod_file = "dist/d3-flamegraph.min.js";
    js_dev_file = "dist/d3-flamegraph.js";
  }
  {
    name = "pako";
    version = "1.0.11";
    hash = "sha256-St7nKpcYlJQl8qMmPkEHwmTufOHAeZK4lBZHo8VRXLA=";
    js_prod_file = "dist/pako.min.js";
    js_dev_file = "dist/pako.js";
  }
  {
    name = "react";
    version = "16.14.0";
    hash = "sha256-X/8Bc4XvC8IqQWbW/PCRJQpmOBI/0AZT/hSFBf/uJU8=";
    js_prod_file = "umd/react.production.min.js";
    js_dev_file = "umd/react.development.js";
  }
  {
    name = "react-dom";
    version = "16.14.0";
    hash = "sha256-2mYm9dwBFrWws6CB5bL6ghROTzX84RLM31hdnEbhG10=";
    js_prod_file = "umd/react-dom.production.min.js";
    js_dev_file = "umd/react-dom.development.js";
  }
]
