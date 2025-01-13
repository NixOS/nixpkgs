from types import ModuleType
from typing import Any, Callable


def get_qualified_name(
    method: Callable[..., Any],
    module: ModuleType | None = None,
) -> str:
    module_name = getattr(module, "__name__", method.__module__)
    method_name = getattr(method, "__qualname__", method.__name__)
    return f"{module_name}.{method_name}"
