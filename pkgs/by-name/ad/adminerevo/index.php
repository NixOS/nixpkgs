<?php

namespace nixos {
	function adminer_object() {
		require_once(__DIR__ . '/plugins/plugin.php');

		$plugins = [];
		if (file_exists(__DIR__ . '/plugins.json')) {
			$names = json_decode(file_get_contents(__DIR__ . '/plugins.json'), true);

			foreach ($names as $name) {
				$plugin = __DIR__ . '/plugins/' . $name . '.php';
				if (is_readable($plugin)) {
					require($plugin);

					preg_match_all('/(\w+)/', $name, $matches);

					$className = 'Adminer'. implode('', array_map('ucfirst', $matches[1]));

					$plugins[] = new $className;
				}
			}
		}

		return new \AdminerPlugin($plugins);
	}
}

namespace {
	function adminer_object() {
		return \nixos\adminer_object();
	}

	require(__DIR__ . '/adminer.php');
}
