from collections.abc import Callable
from types import ModuleType
from typing import Any


def get_qualified_name(
    method: Callable[..., Any],
    module: ModuleType | None = None,
) -> str:
    module_name = getattr(module, "__name__", method.__module__)
    method_name = getattr(method, "__qualname__", method.__name__)
    name = f"{module_name}.{method_name}"
    assert name.startswith("nixos_rebuild"), (
        f"Non-internal module '{name}' called with 'get_qualified_name'"
    )
    return name
