<?php

declare(strict_types=1);

namespace nixos {
    use AdminerPlugin;

    use function sprintf;

    function adminer_object(): object
    {
        require_once __DIR__ . '/plugins/plugin.php';

        if (!file_exists(__DIR__ . '/plugins.json')) {
            return new AdminerPlugin();
        }

        $plugins = array_map(
            static function (string $name): ?object {
                $plugin = sprintf('%s/plugins/%s.php', __DIR__, $name);

                if (!is_readable($plugin)) {
                    return null;
                }

                require $plugin;

                preg_match_all('/(\w+)/', $name, $matches);

                return new sprintf('Adminer%s', implode('', array_map('ucfirst', $matches[1])));
            },
            json_decode(file_get_contents(sprintf('%s/plugins.json', __DIR__), true))
        );

        return new AdminerPlugin(array_filter($plugins));
    }
}

namespace {
	function adminer_object() {
		return \nixos\adminer_object();
	}

	require(__DIR__ . '/adminer.php');
}
