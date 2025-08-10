import logging
from collections.abc import Sequence
from mitmproxy import ctx, http
import re


logger = logging.getLogger(__name__)


class RegexLogger:
    def __init__(self):
        self.verbose_patterns = None

    def load(self, loader):
        loader.add_option(
            name="verbose_pattern",
            typespec=Sequence[str],
            default=[],
            help="Regex patterns for verbose logging",
        )

    def response(self, flow: http.HTTPFlow):
        if self.verbose_patterns is None:
            self.verbose_patterns = [re.compile(p) for p in ctx.options.verbose_pattern]

        matched = any(p.search(flow.request.path) for p in self.verbose_patterns)
        if matched:
            logger.info(format_flow(flow))


def format_flow(flow: http.HTTPFlow) -> str:
    return (
        "\n"
        "RequestHeaders:\n"
        f"    {format_headers(flow.request.headers.items())}\n"
        f"RequestBody:     {flow.request.get_text()}\n"
        f"Status:          {flow.response.data.status_code}\n"
        "ResponseHeaders:\n"
        f"    {format_headers(flow.response.headers.items())}\n"
        f"ResponseBody:    {flow.response.get_text()}\n"
    )


def format_headers(headers) -> str:
    return "\n    ".join(k + ": " + v for k, v in headers)


addons = [RegexLogger()]
